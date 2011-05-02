
class util {
public:
	void static NavigateToUrl(String url) {
		NSString *stringUrl = tonsstr(url);
		NSURL *nsUrl = [NSURL URLWithString:stringUrl];
		[[UIApplication sharedApplication] openURL:nsUrl];

	}
};