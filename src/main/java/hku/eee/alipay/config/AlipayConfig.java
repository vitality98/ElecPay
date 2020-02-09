package hku.eee.alipay.config;

public class AlipayConfig {
	// 商户appid
	public static String APPID = "2016101800713096";
	// 私钥 pkcs8格式的
	public static String RSA_PRIVATE_KEY = "MIIEvAIBADANBgkqhkiG9w0BAQEFAASCBKYwggSiAgEAAoIBAQCEsGCVZNpurImcUd5Be6BmjcYSOVAn0CJnmg/Q1EwpwrFnykDF0HR8zT18fWsap5otb4ZsF6an2xHnNh4x0St60ml3KS6Rcqn/0NuMmkRy79uWlCirqzWCaDlBrb6YVzvV2A/36i68Y1NgncM4Sguw9jt3uWnNQqiSreQ5KqZzJ9c7e0wzxjQiYYIAb4iTXzJCap0S4S/XQisy4OridUe8tjqL941A6HMphLqT4zSxcHaYhEfWG0rpSE03+Ap/8JGbWQJPh+/1jjWJto7x9cXrhcbzGMZOrj3jhfLKMp6cDobo4Rz5IPMaMG4BHQ0HI/t/0NBmQKRCrB+PrNCt5zIhAgMBAAECggEAT47tqkW5Tsi3Dfpsd/jnOPZiv8SLkgOSzWmrd/wC2rs44dF8Ot99KONqrX0JvgamQ/3trFwV+ek5d9eUDSyslE0bHW6c1GrbEV6qdUh+KCg3ErctF5llURaq1f2WHQOZBeQx1uUcNqqbcH/HcLW9AtLw3x1WGdOQ/bmz8K7o9HwcdoqSMUMYFGhWIqHBAW7aVecR3GP2iRGSElrry/nV9srrSabBeBPGwvboglOiIeG74jYv0UFO81ZRv8+B84Rh486TafhLl1KjroBb4baYW9iq3HWq+r5uDT136TeTNJXWmezzoxlGsOjFarTqdY+XC6gJoZVdgi3hLITl0sptUQKBgQDVxXKS8eKZpt2bnTu/zOrZvT9JUBuJ/fgh6TGTeSkwRYAqE4EABN+2mevjdrqiDLa393OCvr7J5Ep+Jla+6X3vulC92H2KUMEvZzpVkIf1t0/iB0BgBcnfHshvGWD6oHdbWb9W87bTPVu2j81N/+DtTrhm74pPxqUSkrQMe/eQpQKBgQCe5ot8AzpGQW0litvWJiAmUzeq9XBh33bt1A2mKBsUvrFOAyuACVw39BB0tLmVUv97GMtjBvnKP5jXcIeiincASmZnu5JqmPZBmeHVVqZ8O0QSh92JcUtZ8XRkG9+0DBr1EhbdMa1Egd4xilOGEpqarQNmWHhunKUNbbeBUoqGzQKBgGdMm1oAwuRG6y2IZFgBuLbxKUTPDg+3hxEz8330/X9TBmTOufZ9ZHGDnaZ0OCmYhS8Ox2W1sNI0m/6rnh1xDScr3Fpw4/FTppa2hkzUo66MH3D02hnMkklcQbTWCbPymNqu2rQ03vLi4o+sm6QGcvWZpagwNqDoN9pqw9CIkw/1AoGAf7LPTe5aGrPhv1YErekd1S7zgdSVaFJqBV9xSKLagKVvYD5z6wWasuzVfLTwn+x/nLGkYgTtIXhSoHCy0BFu6TDhc2PumvQqkzXTo9trGFOYtTuy8g22fKXq37j24n8H+wN6lHCjynaD1lRQI2M4FC4OmWVoA5ynmE8gNjHbWdECgYASpBeyHyhz1JUiR8mI7LLfIslf/7omorNk7dM3t3bsi7FXC8nYoitnpL2iJ4Gp5v3FU89p8FVUJgeqTGXwgXKqqTrx7SQBkUEL0yk746y2HQcvsvAMMkyTyyMqdErEjubhIUK/1jeN2b4O6Iuf5Tr1l2vMTnwHEEtPPrX3Nta6oA==";
	// 服务器异步通知页面路径 需http://或者https://格式的完整路径，不能加?id=123这类自定义参数，必须外网可以正常访问
	public static String notify_url = "http://商户网关地址/alipay.trade.wap.pay-JAVA-UTF-8/notify_url.jsp";
	// 页面跳转同步通知页面路径 需http://或者https://格式的完整路径，不能加?id=123这类自定义参数，必须外网可以正常访问 商户可以自定义同步跳转地址
	public static String return_url = "http://localhost:8080/account/topupReturn.do";
	// 请求网关地址
	public static String URL = "https://openapi.alipaydev.com/gateway.do";
	// 编码
	public static String CHARSET = "UTF-8";
	// 返回格式
	public static String FORMAT = "json";
	// 支付宝公钥
	public static String ALIPAY_PUBLIC_KEY = "MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAkb4jKyibWtPeV2A3ewa4NFwzkCJNDjjFtQ2IJn6l8H8Zvnjt7ZOztU4fPxUT9MIIcvOlsz+FpLgZiV8X5cDBsQVF6He/gVyzyR7nu6s2az+chshmoG6MINp4S22LTU7F9NE2HpaZgEWSLVUU8xE5sgDFsELKWNBGqFwAPZUt4s11nD7UtGpPYNeI1c6UOMrU+zcpc97tRZ2NBzLQULONVVC5FvrU6gSAKu0zysie00y4owLJIetExnngVfCFSjIJRSby7xOafPN+XJdylRdm/aHqydB3MogH+rT4PRMzdT+m06y9dV4iwJim5SRJw3o79iwQaHnrLma7k3Fsfq84xQIDAQAB";
	// 日志记录目录
	public static String log_path = "/log";
	// RSA2
	public static String SIGNTYPE = "RSA2";
}
