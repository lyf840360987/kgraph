package kgraph;

import java.io.BufferedReader;
import java.io.FileNotFoundException;
import java.io.FileReader;
import java.io.IOException;
import java.util.HashSet;
import java.util.Iterator;
import java.util.List;
import java.util.Scanner;
import java.util.Set;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

import org.neo4j.driver.v1.AuthTokens;
import org.neo4j.driver.v1.Driver;
import org.neo4j.driver.v1.GraphDatabase;
import org.neo4j.driver.v1.Record;
import org.neo4j.driver.v1.Session;
import org.neo4j.driver.v1.StatementResult;
import org.neo4j.driver.v1.Transaction;
import org.neo4j.driver.v1.Value;
import org.neo4j.driver.v1.Values;
import org.neo4j.driver.v1.types.Node;
import org.neo4j.driver.v1.types.Path;
import org.neo4j.driver.v1.types.Relationship;

public class ToJson { 
	public static void main(String[] args) throws IOException {
		Scanner sc=new Scanner(System.in);
		String ss=sc.nextLine();
		System.out.print(getJson(ss));
		getJson(ss);
//		getNodeInfo("ss");
//		giveNodeInfo("dd");
//		getPathsInfo("match r=(n:Item)-[]->(p:Attribute) where n.name='����' return r");
	}
	public static JSONObject getJson(String query){
		JSONArray relation=getPathsInfo(query);
		JSONArray node=getRelationNodeInfo(query);
		JSONObject obj = new JSONObject();
		obj.put("links", relation);
		obj.put("nodes", node);
		return obj;
	}
	public static void giveNodeInfo(String query) throws IOException {
		Driver driver = GraphDatabase.driver("bolt://localhost:7687",AuthTokens.basic("neo4j", "l840360987"));
		BufferedReader reader = new BufferedReader(new FileReader("F:\\neo4j-community-3.5.12\\import\\ownthink_v2.csv"));
		String line = null;
		//Scanner sc = new Scanner(System.in);
		line = reader.readLine();
		int n = 0;
		try (Session session = driver.session()) {
			while ((line = reader.readLine()) != null) {
				System.out.println(line);
				line = line.replace("\\", "\\\\");
				line = line.replaceAll("��", "��");
				String item[] = line.split(",");
				if (item.length < 3) {
					continue;
				}
				// item[2]=item[2].replaceAll("��", "��");
				item[2] = item[2].replaceAll(" ", "");
				query = "MATCH(n:Item),(b:Attribute) where n.name='" + item[0]+ "' and b.name='" + item[2] + "'  merge (n)-[r:"+ item[1] + "]->(b) return n,b";
				System.out.println(query);
				n++;
				try (Transaction transaction = session.beginTransaction()) {
					transaction.run("merge (n:Item{name:'" + item[0]+ "'}) return n");
					transaction.run("merge (n:Attribute{name:'" + item[2]+ "'}) return n");
					transaction.run(query);
					// transaction.run("create(n:A1{NAME:'liyufan',TITLE:'����'})",Values.parameters("NAME","james","TITLE","King"));
					transaction.success();
				} catch (Exception e) {
					System.out.println("������������" + n);
				}
			}
			System.out.println(n);
		}
		driver.close();
	}

	public static void getNodeInfo(String query) {
		Driver driver = GraphDatabase.driver("bolt://localhost:7687",AuthTokens.basic("neo4j", "l840360987"));
		Session session = driver.session();
		try (Transaction tx = session.beginTransaction()) {
			// StatementResult result =
			// tx.run("MATCH (n:Item) where n.name='"+s+"' return n");
			StatementResult result = tx.run("MATCH (n) where n.name='"+query+"' RETURN n");
			while (result.hasNext()) {
				Record record = result.next();
				List<Value> value = record.values();
				for (Value i : value) {
					Node node = i.asNode();
					Iterator keys = node.keys().iterator();
					System.out.println(node.id());
					Iterator<String> nodeTypes = node.labels().iterator();
					String nodeType = nodeTypes.next();
					System.out.println("�ڵ����ͣ�" + nodeType);
					System.out.println("�ڵ��������£�");
					while (keys.hasNext()) {
						String attrKey = (String) keys.next();
						String attrValue = node.get(attrKey).asString();
						System.out.println(attrKey + "-------" + attrValue);
					}
					System.out.println("~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~");
				}
				// System.out.println(String.format("%s",record.getString("NAME")));
				// System.out.println(result.next().toString());
			}
			tx.success();
		}
		driver.close();
	}

	public static JSONArray getPathsInfo(String query) {
		Driver driver = GraphDatabase.driver("bolt://localhost:7687",
				AuthTokens.basic("neo4j", "l840360987"));
		 //��ϵ��StringBuffer,json��ʽ
        StringBuffer relationBuffer = new StringBuffer("");
        StringBuffer nodeBuffer = new StringBuffer("");
        //relationBuffer.append("\"links\":[");//return "links":[
        relationBuffer.append("[");
        nodeBuffer.append("[");
		int count = 0;
		query="match r=(n:Item)-[]->(p:Attribute) where n.name='"+query+"' return r";
		try (Session session = driver.session()) {
			// result���������е�path
			StatementResult result = session.run(query);
			while (result.hasNext()) {
				Record record = result.next();
				List<Value> value = record.values();
				for (Value i : value) {
					Path path = i.asPath();
					//String[] name=new String[2]; //��ȡ�ڵ����֣�������һ����ִ��
					// ����·���еĹ�ϵ
					Iterator<Relationship> relationships = path.relationships().iterator();
					//Iterator<Node> nodes =path.nodes().iterator();//�õ�path�еĽڵ�
					/*
					int sum=0;
					while(nodes.hasNext()){
						
						Node node=nodes.next();
						Iterator keys = node.keys().iterator();
						Iterator nodeTypes = node.labels().iterator();
						while (keys.hasNext()) {
							String attrKey = (String) keys.next();
							String attrValue = node.get(attrKey).asString();
							if(attrKey.equals("name")){
								name[sum]=attrValue;
								sum++;
							}
						}
					}
					*/
					while (relationships.hasNext()) {
						count++;
						Relationship relationship = relationships.next();
						long startNodeId = relationship.startNodeId();
						long endNodeId = relationship.endNodeId();
						String relType = relationship.type();
						relationBuffer.append("{");
                        relationBuffer.append("\"source\":");
                        relationBuffer.append("\""+startNodeId+"\"");
                        //relationBuffer.append("\""+name[0]+"\"");
                        relationBuffer.append(",");
                        relationBuffer.append("\"target\":");
                        relationBuffer.append("\""+endNodeId+"\"");
                        //relationBuffer.append("\""+name[1]+"\"");
                        relationBuffer.append(",");
                       // relationBuffer.append("\"value\":5,");
                        relationBuffer.append("\"label\":");
                        relationBuffer.append("\""+relType+"\"");
                        /*
						System.out.println("��ϵ" + count + "�� ");
						System.out.println("��ϵ���ͣ�" + relType);
						System.out.println("from " + startNodeId + "-----"+ "to " + endNodeId);
						System.out.println("from " + name[0] + "-----"+ "to " + name[1]);
						
						System.out.println("��ϵ�������£�");
						// �õ���ϵ���ԵĽ�
						Iterator<String> relKeys = relationship.keys().iterator();
						// ���ﴦ���ϵ����
						while (relKeys.hasNext()) {
							String relKey = relKeys.next();
							String relValue = relationship.get(relKey).asObject().toString();
							System.out.println(relKey + "-----" + relValue);
						}
						*/
						if(!relationships.hasNext()&&!result.hasNext()){
                            relationBuffer.append("}");
                        }
                        else {
                            //��������һ����ֻ��Ҫ���}����
                            relationBuffer.append("},");
                        }
						//System.out.println("~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~");
					}
				}
			}

		}
		//ToJson toJson = new ToJson(relationNodesBuffer,relationBuffer);
		relationBuffer.append("]");
		System.out.println(relationBuffer);
		JSONArray json = JSONArray.fromObject(relationBuffer.toString());
		driver.close();
		return json;

	}
	public static JSONArray getRelationNodeInfo(String query) {
		Driver driver = GraphDatabase.driver("bolt://localhost:7687",
				AuthTokens.basic("neo4j", "l840360987"));
		 //��ϵ��StringBuffer,json��ʽ
		Set nodeSet = new HashSet();
        StringBuffer nodesBuffer = new StringBuffer("");
        nodesBuffer.append("[");
		query="match r=(n:Item)-[]->(p:Attribute) where n.name='"+query+"' return r";
		try (Session session = driver.session()) {
			// result���������е�path
			StatementResult result = session.run(query);
			while (result.hasNext()) {
				Record record = result.next();
				List<Value> value = record.values();
				for (Value i : value) {
					Path path = i.asPath();
					// ����·���еĹ�ϵ
					Iterator<Node> nodes =path.nodes().iterator();//�õ�path�еĽڵ�
					while(nodes.hasNext()){
						Node node=nodes.next();
						if(nodeSet.contains(node.id()))
							continue;
						nodeSet.add(node.id());
						Iterator<String> nodeKeys = node.keys().iterator();
                        nodesBuffer.append("{");
                       
                        while (nodeKeys.hasNext()) {
							String nodeKey = nodeKeys.next();
							//nodesBuffer.append("\""+nodeKey+"\":");
							nodesBuffer.append("\"label\":");
							String content = node.get(nodeKey).asObject().toString();
                            //ȥ���Ʊ��
                            content = content.replaceAll("\t","");
                            //ȥ�����з�
                            content = content.replaceAll("\r","");
                            //ȥ���س���
                            content = content.replaceAll("\n","");
                            //��˫���Ż��ɵ�����
                            content = content.replaceAll("\"","'");
                            nodesBuffer.append("\""+content+"\",");
						}
						//nodesBuffer.append("\"id\":");
                        nodesBuffer.append("\"id\":");
                        nodesBuffer.append(node.id());
                        nodesBuffer.append(",");
                        nodesBuffer.append("\"name\":");
                        nodesBuffer.append("\""+node.id()+"\"");
                        Iterator<String> nodeTypes = node.labels().iterator();
                        //�õ��ڵ������ˣ�
                        String nodeType = nodeTypes.next();
                        nodesBuffer.append(",");
                        nodesBuffer.append("\"category\":");
                        nodesBuffer.append("\""+nodeType+"\"");
                        if(!nodes.hasNext()&&!result.hasNext()){
                            nodesBuffer.append("}");
                        }
                        else{
                            nodesBuffer.append("},");
                        }
					}
				}
			}

		}
		int bufferLength = nodesBuffer.length();
        char lastChar = nodesBuffer.charAt(bufferLength-1);
        if(lastChar==','){
            String str = nodesBuffer.substring(0,nodesBuffer.length()-1);
            nodesBuffer = nodesBuffer.replace(0,bufferLength,str);
        }
        nodesBuffer.append("]");
		//ToJson toJson = new ToJson(relationNodesBuffer,relationBuffer);
		JSONArray json = JSONArray.fromObject(nodesBuffer.toString());
		driver.close();
		return json;

	}
}
