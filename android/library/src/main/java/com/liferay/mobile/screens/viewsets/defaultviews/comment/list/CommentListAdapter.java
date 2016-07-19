package com.liferay.mobile.screens.viewsets.defaultviews.comment.list;

import android.support.annotation.NonNull;
import android.text.Html;
import android.view.View;
import android.widget.TextView;
import com.liferay.mobile.screens.R;
import com.liferay.mobile.screens.base.list.BaseListAdapter;
import com.liferay.mobile.screens.base.list.BaseListAdapterListener;
import com.liferay.mobile.screens.models.CommentEntry;

/**
 * @author Alejandro Hernández
 */
public class CommentListAdapter extends BaseListAdapter<CommentEntry, CommentListAdapter.CommentViewHolder> {

	public CommentListAdapter(int layoutId, int progressLayoutId, BaseListAdapterListener listener) {
		super(layoutId, progressLayoutId, listener);
	}

	@NonNull @Override public CommentViewHolder createViewHolder(View view, BaseListAdapterListener listener) {
		return new CommentViewHolder(view, listener);
	}

	@Override protected void fillHolder(CommentEntry entry, CommentViewHolder holder) {
		holder.bind(entry);
	}

	public void setHtmlBody(boolean htmlBody) {
		this._htmlBody = htmlBody;
	}

	public class CommentViewHolder extends BaseListAdapter.ViewHolder {

		public CommentViewHolder(View view, BaseListAdapterListener listener) {
			super(view, listener);

			_userNameTextView = (TextView) view.findViewById(R.id.comment_user_name);
			_bodyTextView = (TextView) view.findViewById(R.id.comment_body);
		}

		public void bind(CommentEntry entry) {
			_userNameTextView.setText(entry.getUserName());

			if (_htmlBody) {
				_bodyTextView.setText(Html.fromHtml(entry.getBody()));
			} else {
				_bodyTextView.setText(Html.fromHtml(entry.getBody()).toString().replaceAll("\n", "").trim());
			}
		}

		private final TextView _userNameTextView;
		private final TextView _bodyTextView;
	}

	private boolean _htmlBody;
}
